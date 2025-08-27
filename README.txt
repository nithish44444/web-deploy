# Digital Notice Board (Node + React) for Azure App Service (Windows)

## Local run
1) Build React
```
cd frontend
npm install
npm run build
cd ..
```
2) Copy build into backend and run API
```
rm -rf backend/build && cp -r frontend/build backend/
cd backend
npm install
npm start
```
Visit http://localhost:8080

## Deploy from local (no GitHub)
Prereqs: Azure CLI logged in (`az login`), existing App Service.

```
# optional: set Node version for Windows App Service
az webapp config appsettings set --resource-group <rg> --name <app-name> --settings WEBSITE_NODE_DEFAULT_VERSION=18.20.3

# package and deploy the backend folder (includes React build)
az webapp deploy --resource-group <rg> --name <app-name> --src-path backend --type zip
```

## (Optional) Azure SQL
Create `Notices` table and seed:
```sql
CREATE TABLE Notices (id INT IDENTITY(1,1) PRIMARY KEY, title NVARCHAR(200) NOT NULL);
INSERT INTO Notices (title) VALUES (N'Welcome to Azure'), (N'Team sync at 4 PM'), (N'Deploy successful');
```
Then set these App Settings:
- DB_SERVER = <server>.database.windows.net
- DB_NAME   = <db>
- DB_USER   = <user>
- DB_PASS   = <password>
