# Azure Shared Image Gallery - Konfiguracja OpenTofu

Ten katalog zawiera konfigurację OpenTofu (Terraform) do tworzenia i zarządzania Azure Shared Image Gallery do przechowywania niestandardowych obrazów maszyn wirtualnych.

## Tworzone zasoby

- **Shared Image Gallery**: Centralne repozytorium dla obrazów VM
- **Image Definition**: Metadane dla niestandardowego obrazu bazowego Debian 12

## Konfiguracja

Galeria jest skonfigurowana z:
- Nazwa: `shared_image_gallery`
- Lokalizacja: France Central (konfigurowalna)
- Definicja obrazu dla maszyn wirtualnych Linux z wydawcą `azpkbc`, ofertą `debian12`, SKU `base`

## Użycie

```bash
# Zainicjalizuj OpenTofu
tofu init

# Zaplanuj wdrożenie
tofu plan

# Zastosuj konfigurację
tofu apply
```

## Zmienne

- `resource_group_name`: Docelowa grupa zasobów (domyślnie: `azpkbc-rg-advanced-labs`)
- `location`: Region Azure (domyślnie: `France Central`)
- `image_name`: Nazwa definicji obrazu (domyślnie: `azpkbc-lab08b-base-image`)

## Backend

Używa backendu Azure Storage Account do zarządzania stanem. Wymaga zmiennej środowiskowej `ARM_SA_TFSTATE_NAME`.

---

<!-- BEGIN_PACKER_DOCS -->

<!-- END_PACKER_DOCS -->
