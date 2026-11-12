const grid = document.querySelector("#product-grid");
const status = document.querySelector("#catalog-status");
const search = document.querySelector("#search");
const sort = document.querySelector("#sort");
let scooters = [];

function formatPrice(value) {
  return new Intl.NumberFormat("pt-PT", { style: "currency", currency: "EUR" }).format(value);
}

function renderScooters() {
  const query = search.value.trim().toLocaleLowerCase("pt-PT");
  const filtered = scooters
    .filter((scooter) => `${scooter.name} ${scooter.description || ""}`.toLocaleLowerCase("pt-PT").includes(query))
    .sort((a, b) => sort.value === "price-asc" ? a.price - b.price : sort.value === "price-desc" ? b.price - a.price : a.id - b.id);

  status.textContent = `${filtered.length} ${filtered.length === 1 ? "modelo disponível" : "modelos disponíveis"}`;
  grid.innerHTML = filtered.length ? filtered.map((scooter) => `
    <article class="product-card">
      <div class="product-image"><img src="${escapeAttribute(scooter.image_url || "/assets/images/scooters/scooter-placeholder.svg")}" alt="Trotinete elétrica ${escapeAttribute(scooter.name)}" loading="lazy"></div>
      <div class="product-content">
        <div class="product-top"><h3>${escapeHTML(scooter.name)}</h3><span class="product-price">${formatPrice(Number(scooter.price))}</span></div>
        <p class="product-description">${escapeHTML(scooter.description || "Modelo VoltRide.")}</p>
        <div class="product-specs"><span>${Number(scooter.motor_watts)} W</span><span>${Number(scooter.range_km)} km</span><span>${Number(scooter.weight_kg)} kg</span></div>
        <a class="configure-link" href="#personalizar" data-scooter="${Number(scooter.id)}">Conhecer modelo →</a>
      </div>
    </article>`).join("") : '<p class="empty-state">Não encontrámos modelos para esta pesquisa.</p>';
}

function escapeHTML(value) {
  return String(value).replace(/[&<>"']/g, (character) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[character]);
}

function escapeAttribute(value) {
  return escapeHTML(value);
}

async function loadScooters() {
  try {
    const response = await fetch("/api/scooters");
    if (!response.ok) throw new Error("Não foi possível carregar o catálogo.");
    const payload = await response.json();
    scooters = payload.data;
    renderScooters();
  } catch (error) {
    status.innerHTML = `<span class="error-message">O catálogo ainda não está disponível. Confirma a ligação MySQL e os dados iniciais. ${escapeHTML(error.message)}</span>`;
    grid.replaceChildren();
  }
}

search.addEventListener("input", renderScooters);
sort.addEventListener("change", renderScooters);
loadScooters();
