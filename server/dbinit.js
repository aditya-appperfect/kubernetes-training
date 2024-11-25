const { Client } = require("pg");

async function initDb() {
  const client = new Client({
    user: "postgres",
    host: "postgres",
    database: "devopstestdb",
    password: "App4ever#",
    port: 5432,
  });

  try {
    await client.connect();

    const res = await client.query(
      `SELECT 1 FROM pg_database WHERE datname = 'devopstestdb'`
    );

    if (res.rows.length === 0) {
      console.log("Database 'devopstestdb' does not exist. Creating it...");
      await client.query("CREATE DATABASE devopstestdb");
    } else {
      console.log("Database 'devopstestdb' already exists.");
    }

    await client.end();
  } catch (err) {
    console.error("Error initializing database:", err);
  }
  try {
    const newClient = new Client({
      user: "postgres",
      host: "postgres",
      database: "devopstestdb",
      password: "App4ever#",
      port: 5432,
    });

    await newClient.connect();

    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS time_data (
        id SERIAL PRIMARY KEY,
        time_value VARCHAR(100),
        call_count INT DEFAULT 0
      );
    `;
    await newClient.query(createTableQuery);
    await newClient.query(
      `INSERT INTO time_data (time_value) VALUES (CURRENT_TIMESTAMP)`
    );
    console.log('Table "time_data" created or already exists.');

    await newClient.end();
  } catch (error) {
    console.error("Table Error: ", error);
  }
}

initDb();
