const express = require("express");
const sql = require("mssql");
const path = require("path");

const app = express();

const dbcfg = {
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  server: process.env.DB_SERVER, // e.g. myserver.database.windows.net
  database: process.env.DB_NAME,
  options: { encrypt: true, trustServerCertificate: false }
};

app.get("/api/health", (req, res) => res.json({ ok: true }));

app.get("/api/notices", async (req, res) => {
  try {
    if (!dbcfg.server) return res.json([]); // allow running without DB
    const pool = await sql.connect(dbcfg);
    const result = await pool.request().query("SELECT TOP 20 * FROM Notices ORDER BY id DESC");
    res.json(result.recordset);
  } catch (err) {
    console.error(err.message);
    res.json([]);
  }
});

// Serve React build
app.use(express.static(path.join(__dirname, "build")));
app.get("*", (_req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));
