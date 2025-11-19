# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Base image with only the runtime dependencies installed (Chiseled variant for smaller image size, extra for ICU, tzdata and stdc++)
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble-chiseled-extra AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

# This stage is used to build the service project
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG TARGETARCH
WORKDIR /src
# Install clang/zlib1g-dev dependencies for publishing to native
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    clang zlib1g-dev \
    && if [ "$TARGETARCH" = "arm64" ]; then apt-get install -y --no-install-recommends gcc-aarch64-linux-gnu libc6-dev-arm64-cross binutils-aarch64-linux-gnu; fi \
    && rm -rf /var/lib/apt/lists/*
COPY ["Api/Api.csproj", "Api/"]
RUN dotnet restore "./Api/Api.csproj"
COPY . .
WORKDIR "/src/Api"
RUN dotnet build "./Api.csproj" -a $TARGETARCH -c $BUILD_CONFIGURATION -o /app/build
# Setup objcopy for ARM64 cross-compilation
RUN if [ "$TARGETARCH" = "arm64" ]; then ln -sf /usr/bin/aarch64-linux-gnu-objcopy /usr/local/bin/objcopy; fi
RUN dotnet publish "./Api.csproj" -a $TARGETARCH -c $BUILD_CONFIGURATION -o /app/publish

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["/app/Api"]
