# Etapa 1: Compilación de la aplicación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# Utiliza una imagen oficial de Microsoft que incluye el SDK de .NET 9.0
# Esta imagen permite compilar, restaurar paquetes y publicar la app
WORKDIR /publish
# Establece el directorio de trabajo dentro del contenedor para las operaciones que siguen

COPY ./AcademiaNovit/AcademiaNovit.csproj ./
# Copia solo el archivo del proyecto (.csproj) para restaurar dependencias antes de copiar todo el código
# Esto permite aprovechar la caché de Docker si no cambió el archivo .csproj
RUN dotnet restore
# Restaura los paquetes NuGet necesarios para el proyecto

COPY ./AcademiaNovit ./
# Copia el resto de los archivos del proyecto (código fuente, vistas, etc.)
RUN dotnet publish -c Release -o out
# Publica la aplicación en modo Release y genera los archivos compilados en la carpeta 'out'

# Etapa 2: Imagen final para ejecutar la aplicación (más liviana)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
# Usa una imagen más liviana que solo contiene el runtime de ASP.NET Core 9.0
# Esta imagen es ideal para producción porque no incluye el SDK completo
WORKDIR /publish
# Establece el directorio de trabajo en el contenedor de ejecución

COPY --from=build /publish/out ./
# Copia los archivos publicados desde la etapa de compilación a esta imagen

EXPOSE 8080
# Expone el puerto 8080 para permitir que la aplicación escuche conexiones externas en ese puerto

ENTRYPOINT ["dotnet","AcademiaNovit.dll"]
# Define el punto de entrada del contenedor: ejecuta la aplicación .NET