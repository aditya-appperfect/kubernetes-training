const express = require("express");
const { Pool } = require("pg");
const moment = require("moment");
const cors = require("cors");

const app = express();
const port = 8080;

const corsOptions = {
  origin: ["http://localhost:3000", "http://127.0.0.1:3000"]
};

app.use(cors(corsOptions));

const pool = new Pool({
  user: "postgres",
  host: "postgres",
  database: "devopstestdb",
  password: "App4ever#",
  port: 5432,
});

app.get("/api/time", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM time_data");
    const data = result.rows[0];

    const currentTime = moment().format("YYYY-MM-DD HH:mm:ss");

    await pool.query(
      "UPDATE time_data SET call_count = call_count + 1"
    );

    await pool.query("UPDATE time_data SET time_value = $1", [
      currentTime,
    ]);

    res.json({ time: currentTime, callCount: data.call_count + 1 });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

app.get("/", async (req, res) => {
  res.status(200).json("Hello Server");
});

app.listen(port, () => {
  console.log(`Backend running on http://localhost:${port}`);
});
