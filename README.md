# 📱 MyCajaApp

# MyCajaApp es una aplicación construida con SwiftUI, diseñada como una solución de punto de venta para pequeños negocios. Ofrece funcionalidades de gestión de productos, registro de ventas y consulta de historial, todo completamente offline. Esta app también implementa un menú tipo hamburguesa personalizable, ideal como base para otros desarrolladores que deseen integrar navegación lateral en sus propias apps iOS.

# Características

    Menú lateral tipo hamburguesa para navegar entre las diferentes secciones.

    Gestíon de productos, permitiendo listar y administrar productos.

    Registro de ventas para realizar nuevas transacciones.

    Historial de ventas para consultar ventas anteriores.
    
# Instalación y Uso

    Clonar el repositorio:

    git clone https://github.com/manolo-94/MyCajaApp.git

    Abrir el proyecto en Xcode.
    
    Ejecutar la aplicación en un simulador o dispositivo.

# 📁 Estructura del proyecto
MyCaja
├── MyCajaApp.swift            # Punto de entrada de la app
├── ContentView.swift          # Vista principal con el menú y navegación
├── Assets.xcassets            # Recursos gráficos (íconos, colores)
│   ├── AccentColor.colorset
│   ├── AppIcon.appiconset
│   └── Contents.json
├── Config                     # Configuración de la app
├── Extensions                 # Extensiones útiles para SwiftUI
├── Item.swift                 # Modelo de datos principal
├── Models                     # Modelos de datos
│   └── menu
│       └── MenuOption.swift   # Opciones del menú lateral
├── Persistence                # Persistencia de datos (Core Data, SwiftData)
├── Preview Content            # Recursos para previsualización en SwiftUI
│   └── Preview Assets.xcassets
│       └── Contents.json
├── Resources                  # Archivos adicionales como JSON o fuentes
├── Services                   # Servicios para la lógica de negocio y datos
├── Utils                      # Métodos y funciones auxiliares
├── ViewModels                 # Lógica de presentación (MVVM)
└── Views                      # Todas las vistas de la app
    ├── ContentView.swift      # Maneja la navegación y el estado del menú
    ├── Home
    │   └── HomeView.swift     # Vista de inicio
    ├── Main
    │   └── MainView.swift     # Contenedor principal de la app
    ├── Menu                   # Implementación del menú lateral
    │   ├── SideMenuRow.swift  # Representa cada opción del menú
    │   └── SideMenuView.swift # Vista completa del menú
    ├── Product
    │   └── ProductListView.swift # Listado de productos
    ├── Sale
    │   └── SaleView.swift     # Vista para registrar una venta
    ├── SalesHistory
    │   └── SalesHistoryListView.swift # Historial de ventas
    └── Shared                 # Componentes reutilizables
        ├── ErrorView.swift    # Vista genérica para errores
        ├── HeaderView.swift   # Encabezado con botón del menú
        └── LoadingView.swift  # Indicador de carga


# 🛠️ Requisitos
    Xcode 15+
    iOS 17+
    SwiftUI

# 🔄 Futuras características
    Sincronización en la nube mediante backend personalizado.
    Respaldo automático de datos.
    API REST y versión web.
