# Tworzenie małego, czytelnego obrazu VM z narzędziami tekstowymi - Packer

Przykładowa konfiguracja HashiCorp Packer demonstruje tworzenie niestandardowego,
zoptymalizowanego obrazu maszyny wirtualnej w Azure. Obraz oparty jest na
Debian 12, zawierającym podstawowe narzędzia do przetwarzania tekstu i
pracy z plikami. Rozwiązanie skupia się na minimalizacji rozmiaru przy
zachowaniu funkcjonalności niezbędnej do codziennej pracy z infrastrukturą
w chmurze.

## Wymagania wstępne

Przed przystąpieniem do tworzenia obrazu należy spełnić następujące wymagania.
Konfiguracja wymaga dostępu do środowiska Azure oraz podstawowych narzędzi
do zarządzania infrastrukturą jako kodem. Wszystkie zasoby są tworzone w
istniejącej grupie zasobów, co pozwala na integrację z pozostałymi laboratoriami
i uniknięcie konfliktów nazw.

* Packer w wersji 1.10 lub nowszej
* Azure CLI zainstalowany i skonfigurowany z aktywną subskrypcją
* Istniejąca grupa zasobów `azpkbc-rg-advanced-labs` w regionie France Central
* Aktywne logowanie Azure CLI (`az login`) z skonfigurowaną subskrypcją
* Klucz SSH typu Ed25519 dostępny w lokalizacji `~/.ssh/id_ed25519_az.pub`

## Architektura rozwiązania

Konfiguracja implementuje proces tworzenia obrazu VM w trzech głównych etapach.
Najpierw tworzona jest tymczasowa maszyna wirtualna z zainstalowanym oprogramowaniem,
następnie wykonywana jest generalizacja systemu, a na końcu tworzony jest obraz
gotowy do wielokrotnego użytku. Takie podejście zapewnia spójność i powtarzalność
wdrażania środowisk deweloperskich.

### Składniki infrastruktury

Rozwiązanie składa się z kilku powiązanych ze sobą zasobów Azure, które
współpracują ze sobą w celu utworzenia finalnego obrazu. Każdy komponent
odgrywa kluczową rolę w procesie budowania optymalnego środowiska pracy.

* **Maszyna wirtualna**: Tymczasowa instancja używana do przygotowania obrazu
* **Interfejs sieciowy**: Zapewnia łączność z istniejącą siecią wirtualną
* **Dysk systemu operacyjnego**: 30 GB dysk z Debian 12 i narzędziami
* **Rozszerzenie generalizacji**: Przygotowuje VM do utworzenia obrazu
* **Niestandardowy obraz**: Finalny produkt gotowy do użycia

## Struktura projektu

Projekt zorganizowany jest modularnie, z podziałem na pliki odpowiedzialne
za poszczególne aspekty konfiguracji. Taka struktura ułatwia zarządzanie
i modyfikację poszczególnych elementów infrastruktury.

```bash
.
├── versions.pkr.hcl        # Konfiguracja Packer i wymaganych pluginów
├── variables.pkr.hcl       # Definicje zmiennych wejściowych
├── sources.pkr.hcl         # Konfiguracja źródeł (Azure ARM builder)
├── builds.pkr.hcl          # Konfiguracja buildów i provisionerów
├── scripts/                # Skrypty instalacyjne i konfiguracyjne
│   ├── setup-system.sh     # Instalacja narzędzi systemowych
│   ├── setup-ssh-key.tpl.sh # Szablon konfiguracji klucza SSH
│   └── cleanup.sh          # Czyszczenie systemu przed generalizacją
├── .gitignore              # Pliki do ignorowania przez Git
├── .pre-commit-config.yaml # Konfiguracja pre-commit hooks
└── README.md               # Dokumentacja projektu
```

### Szczegóły implementacji

Konfiguracja jest podzielona na modułowe pliki dla lepszej organizacji:
- `versions.pkr.hcl`: Konfiguracja Packer i wymaganych pluginów
- `variables.pkr.hcl`: Zmienne wejściowe (subskrypcja, SSH, konfiguracja obrazu)
- `sources.pkr.hcl`: Konfiguracja źródła Azure ARM builder z jawną autoryzacją Azure CLI
- `builds.pkr.hcl`: Provisionery instalacyjne i czyszczące
- `scripts/`: Zewnętrzne skrypty instalacyjne (łatwiejsze do modyfikacji)

Uwierzytelnianie odbywa się wyłącznie przez Azure CLI dla uproszczenia.
Skrypty instalacyjne automatycznie konfigurują dodatkowy dysk danych (jeśli dostępny)
i montują go w katalogu `/data`. Skrypty są kopiowane na VM i wykonywane sekwencyjnie
podczas budowy obrazu.

### Zainstalowane narzędzia

Obraz zawiera starannie dobrany zestaw narzędzi niezbędnych do pracy z tekstem
i podstawowymi operacjami w środowisku chmurowym. Wybór narzędzi skupia się
na funkcjonalności przy jednoczesnej minimalizacji rozmiaru obrazu.

* **Narzędzia systemowe**: `curl`, `wget`, `bash`, `openssh-client`
* **Narzędzia deweloperskie**: `git`, `vim`, `jq`
* **Narzędzia monitorowania**: `htop`, `net-tools`
* **Azure CLI**: Narzędzie wiersza poleceń dla zarządzania zasobami Azure
* **Biblioteki systemowe**: `ca-certificates` dla bezpiecznej komunikacji
* **Python**: `python3`, `python3-pip` dla skryptów i automatyzacji

### Korzyści Debian 12

Wybór Debian 12 jako systemu bazowego wynika z jego specyficznych cech,
które czynią go idealnym dla lekkich, bezpiecznych obrazów kontenerów i maszyn
wirtualnych. Stabilna dystrybucja z długim okresem wsparcia zapewnia niezawodność
i bezpieczeństwo.

* **Stabilność**: Długoterminowe wsparcie i regularne aktualizacje
* **Bezpieczeństwo**: Proaktywne aktualizacje i minimalna powierzchnia ataku
* **Wydajność**: Szybkie uruchamianie i niskie wymagania pamięci
* **Pakiety**: Spójny system pakietów apt z szeroką gamą oprogramowania
* **Kompatybilność**: Pełna zgodność z standardami Linux i narzędziami

## Metody tworzenia obrazów VM

Istnieje kilka podejść do tworzenia niestandardowych obrazów maszyn wirtualnych
w Azure, w zależności od wymagań projektu, stopnia automatyzacji i dostępnych narzędzi.
Każda metoda ma swoje zalety i zastosowania.

### Packer

**Zalety:**

* Wieloplatformowość (AWS, GCP, Azure)
* Infrastruktura jako kod w formacie HCL
* Możliwość wersjonowania konfiguracji
* Bogata społeczność i pluginy
* Automatyczna generalizacja obrazów

**Wady:**

* Wymaga instalacji dodatkowego narzędzia
* Krzywa uczenia się dla początkujących
* Zależność od lokalnego środowiska

**Kiedy stosować:**

* Multi-cloud deployments
* Złożone konfiguracje obrazów
* Infrastruktura jako kod
* Automatyczne pipeline'y CI/CD

### Azure Image Builder

**Zalety:**

* Pełna integracja z Azure
* Zarządzanie przez Azure Resource Manager
* Możliwość tworzenia obrazów dla wielu platform
* Wbudowane mechanizmy bezpieczeństwa

**Wady:**

* Wymaga znajomości JSON/szablonów ARM
* Dodatkowe koszty za usługę
* Złożoność konfiguracji

**Kiedy stosować:**

* Środowiska produkcyjne w Azure
* Regularne aktualizacje obrazów
* Zautomatyzowane pipeline'y w Azure DevOps

### Porównanie metod

| Metoda        | Złożoność | Automatyzacja | Koszt  | Wieloplatformowość |
|---------------|-----------|---------------|--------|--------------------|
| Packer        | Średnia   | Wysoka        | Niski  | Multi-cloud        |
| Image Builder | Średnia   | Wysoka        | Średni | Azure tylko        |

W tym przykładzie zastosowano metodę Packer, co stanowi dobry punkt wyjścia
do nauki i zastosowań multi-cloudowych.

## Użycie utworzonego obrazu

Po pomyślnym utworzeniu niestandardowego obrazu można go wykorzystać do
wdrażania nowych maszyn wirtualnych. Obraz jest przechowywany w grupie zasobów
i może być referencyjny przez jego ID lub nazwę w kolejnych konfiguracjach.

### W Terraform/OpenTofu

Aby użyć utworzonego obrazu w nowej maszynie wirtualnej, skorzystaj z
źródła danych `azurerm_image` lub bezpośrednio z ID obrazu wyjściowego:

```hcl
# Źródło danych dla istniejącego obrazu
data "azurerm_image" "custom" {
  name                = "azpkbc-lab08b-base-image"
  resource_group_name = "azpkbc-rg-advanced-labs"
}

# Maszyna wirtualna używająca niestandardowego obrazu
resource "azurerm_linux_virtual_machine" "vm_from_image" {
  name                = "my-vm-from-custom-image"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  source_image_id = data.azurerm_image.custom.id

  # Konfiguracja pozostałych parametrów...
}
```

### W Azure CLI

Można również utworzyć maszynę wirtualną bezpośrednio z poziomu wiersza
poleceń Azure CLI, używając ID obrazu zwróconego przez konfigurację Packer:

```bash
# Utworzenie VM z niestandardowego obrazu
az vm create \
  --resource-group azpkbc-rg-advanced-labs \
  --name my-vm-from-image \
  --image /subscriptions/<subscription-id>/resourceGroups/azpkbc-rg-advanced-labs/\
providers/Microsoft.Compute/images/azpkbc-lab08b-base-image \
  --admin-username azureuser \
  --generate-ssh-keys \
  --size Standard_B1s
```

### W Azure Portal

1. Przejdź do **Virtual Machines** w Azure Portal
2. Kliknij **Create** → **Azure virtual machine**
3. W sekcji **Image** wybierz **Browse all public and private images**
4. Znajdź swój obraz w odpowiedniej grupie zasobów
5. Kontynuuj konfigurację maszyny wirtualnej

### Zarządzanie obrazami

Obrazy niestandardowe są zasobami płatnymi w Azure. Aby zoptymalizować koszty:

* **Usuń tymczasową VM**: Packer automatycznie usuwa maszynę wirtualną po zbudowaniu
* **Przechowuj obrazy**: Obrazy można przechowywać w Azure Compute Gallery dla lepszej organizacji
* **Regularne czyszczenie**: Usuwaj nieużywane obrazy, aby uniknąć kosztów przechowywania

## Uruchamianie Packer

### Przygotowanie środowiska

1. Zainstaluj Packer: https://developer.hashicorp.com/packer/downloads
2. Skonfiguruj uwierzytelnianie Azure CLI:

```bash
# Zaloguj się do Azure CLI
az login

# Sprawdź aktywne konto i subskrypcję
az account show

# Ustaw subskrypcję jeśli potrzebujesz (opcjonalne)
az account set --subscription "your-subscription-name"
```

**Ważne**: Upewnij się, że sesja Azure CLI jest aktywna przed uruchomieniem Packer.
Konfiguracja używa jawnego parametru `use_azure_cli_auth = true` dla autoryzacji.

### Konfiguracja dysku danych

Dyski danych są konfigurowane automatycznie przez skrypty instalacyjne.
Jeśli dysk danych jest dostępny podczas budowy, zostanie automatycznie
sformatowany i zamontowany w katalogu `/data`.

### Budowanie obrazu

```bash
# Zainicjalizuj Packer (pobierz pluginy)
packer init .

# Zbuduj obraz (Packer automatycznie wczyta wszystkie pliki *.pkr.hcl)
packer build .
```

### Weryfikacja

Po zakończeniu budowy, Packer wyświetli informacje o utworzonym obrazie:

```
==> azure-arm.debian: Running post-processor: manifest
Build 'azure-arm.debian' finished after 15 minutes 32 seconds.

==> Wait completed after 15 minutes 32 seconds

==> Builds finished. The artifacts of successful builds are:
--> azure-arm.debian: Azure.ResourceManagement.VMImage:

ManagedImageResourceGroupName: azpkbc-rg-advanced-labs
ManagedImageName: azpkbc-lab08b-base-image
ManagedImageLocation: France Central
ManagedImageId: /subscriptions/xxx/resourceGroups/azpkbc-rg-advanced-labs/providers/Microsoft.Compute/images/azpkbc-lab08b-base-image
```

---

<!-- BEGIN_PACKER_DOCS -->

<!-- END_PACKER_DOCS -->
