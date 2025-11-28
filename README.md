# Azure Custom VM Image Packer & Gallery

Projekt demonstruje tworzenie i zarządzanie niestandardowymi obrazami maszyn wirtualnych w Azure przy użyciu HashiCorp Packer i OpenTofu (Terraform).

## Komponenty

- **packer/**: Konfiguracja Packer do budowy minimalnego obrazu VM Debian 12 z podstawowymi narzędziami do przetwarzania tekstu
- **gallery/**: Konfiguracja OpenTofu do tworzenia i zarządzania Azure Shared Image Gallery

## Wymagania wstępne

- Packer 1.10+
- Azure CLI skonfigurowany z aktywną subskrypcją
- OpenTofu 1.10+
- Istniejąca grupa zasobów `azpkbc-rg-advanced-labs` w regionie France Central

## Użycie

1. Zbuduj i opublikuj obraz w Shared Image Gallery:
   ```bash
   cd packer
   ./build-image.sh
   ```
   Skrypt automatycznie inkrementuje wersję, buduje obraz i ustawia end-of-life date (6 miesięcy) oraz rekomendowane specyfikacje VM.

2. Wdróż Shared Image Gallery przy użyciu OpenTofu:
   ```bash
   cd gallery
   tofu init
   tofu plan
   tofu apply
   ```

## Wyniki

- Niestandardowy obraz VM: `azpkbc-lab08b-base-image` z automatycznym wersjonowaniem
- Shared Image Gallery: `shared_image_gallery`
- Wersje obrazów z ustawioną datą end-of-life i rekomendowanymi specyfikacjami VM

---

<!-- BEGIN_PACKER_DOCS -->

<!-- END_PACKER_DOCS -->
