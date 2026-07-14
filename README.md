# Office LTSC 2024 · Instalador interactivo

> **by thealejandro · XACode**

Script `.bat` interactivo para instalar **Office LTSC 2024 Professional Plus** (licencia por volumen) en Windows 10/11 usando el método oficial de Microsoft: la **Office Deployment Tool (ODT)**.

Pensado para técnicos de reparación: se copia a cualquier equipo (USB), doble clic y listo.

## ✨ Qué hace

1. Se autoeleva a administrador (acepta el UAC).
2. Detecta versiones de Office ya instaladas y avisa si hay conflicto (LTSC 2024 **no convive** con Microsoft 365 ni otras versiones Click-to-Run).
3. Menú interactivo: idioma (es-mx / es-es / en-us), arquitectura (64/32 bits) y clave de producto (opcional).
4. Ofrece desinstalar el Office existente antes de instalar.
5. Muestra un resumen y pide confirmación antes de tocar nada.
6. Descarga la ODT oficial desde `officecdn.microsoft.com`, genera el `configuration.xml` (canal `PerpetualVL2024`, producto `ProPlus2024Volume`) e instala (~3–4 GB de descarga).
7. Activa con tu clave vía `ospp.vbs` y muestra el estado de la licencia.

## 🚀 Uso

1. Descarga [`Instalar_Office2024LTSC.bat`](Instalar_Office2024LTSC.bat) (botón **Raw** → guardar, o clona el repo).
2. Doble clic → acepta el UAC → sigue el menú.
3. Ten a mano tu clave de producto (MAK/volumen de 25 caracteres). Puedes omitirla y activar después:

```bat
cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /inpkey:TU-CLAVE-AQUI
cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act
```

## 🔧 Errores de activación frecuentes

| Código | Significado | Solución |
|---|---|---|
| `0x80070005` | Acceso denegado | Ejecutar la activación en CMD **como administrador** |
| `0xC004C060` | Clave **bloqueada** por Microsoft | No tiene arreglo local; reclamar al vendedor una clave válida |
| `0xC004F074` | Busca un servidor KMS que no existe | Suele ser una clave KMS huérfana de un Office anterior: `cscript ospp.vbs /dstatus` para ver sus últimos 5 caracteres y `cscript ospp.vbs /unpkey:XXXXX` para quitarla |
| `OOB_GRACE` | Periodo de gracia | Office funciona; quedan ~30 días para activar |

## ⚠️ Notas

- **Si editas el `.bat`, guárdalo siempre en codificación ANSI/OEM (CP850) con finales de línea CRLF, nunca UTF-8** — cmd no soporta .bat en UTF-8 y los marcos/acentos se rompen. Por eso en el visor de GitHub el archivo se ve con caracteres extraños: es normal, descárgalo tal cual y funcionará.
- Este script **no incluye ni evade licencias**: necesitas una clave legítima de Office LTSC 2024.
- El script excluye Skype for Business (`ExcludeApp Lync`); edita el XML generado si lo necesitas.

---

*XACode — reparación y mantenimiento de equipos*
