import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [currentTime, setCurrentTime] = useState('');
  const [callCount, setCallCount] = useState(0);
  const server = "http://localhost:8080";

  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch(`${server}/api/time`);
      const data = await response.json();
      setCurrentTime(data.time);
      setCallCount(data.callCount);
    };

    fetchData();
  }, []);

  const updateTime = async () => {
      const response = await fetch(`${server}/api/time`);
      const data = await response.json();
      setCurrentTime(data.time);
      setCallCount(data.callCount);
  };

  return (
    <div className="App">
      <h1>Current Time: {currentTime}</h1>
      <h2>Backend Called: {callCount} times</h2>
      <button onClick={updateTime}>Update Time</button>
      <h1>Hello Aditya</h1>
    </div>
  );
}

export default App;
