# 사용할 base 이미지를 선택합니다. Node.js와 Nginx가 함께 포함된 이미지를 사용할수 있습니다.
FROM node:14.17-alpine as build

# 작업 디렉토리를 설정합니다.
WORKDIR /app

# 종속성 설치를 위해 package.json과 package-lock.json 파일을 복사합니다.
COPY package*.json ./

# 종속성 설치를 실행합니다.
RUN npm install

# 프로젝트 파일을 복사합니다.
COPY . .

# 프로젝트를 빌드합니다.
RUN npm run build

# 실제 서비스에 사용할 이미지를 선택합니다. Nginx를 사용하는 경우 Nginx 이미지를 선택합니다.
FROM nginx:latest

# 빌드된 프로젝트 파일을 Nginx의 정적 파일 디렉토리로 복사합니다.
COPY --from=build /app/build /usr/share/nginx/html

# Nginx를 실행합니다.
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]