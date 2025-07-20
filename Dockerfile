FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /publish

COPY ./AcademiaNovit/AcademiaNovit.csproj ./
RUN dotnet restore

COPY ./AcademiaNovit ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /publish

COPY --from=build /publish/out ./

EXPOSE 8080

ENTRYPOINT ["dotnet","AcademiaNovit.dll"]