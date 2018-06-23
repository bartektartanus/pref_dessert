# pref_dessert

Package that allows you persist objects as shared preferences easily. Package name comes from: Shared PREFerences DESerializer/SERializer of T (generic) class.

## Getting Started

To use this package you just need to extend `PreferencesRepository<T>` class, replace generic T class with the one you want to save in shared preferences. This class requires you to implement two methods to serialize and deserialize objects. In future releases I'm planning to use JSON serializer so it will be much simpler to use. 
