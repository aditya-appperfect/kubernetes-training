import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  console.log("Hello in client")
  const [currentTime, setCurrentTime] = useState('');
  const [callCount, setCallCount] = useState(0);
  const server = "http://localhost:8080";

  // useEffect(() => {
  //   const fetchData = async () => {
  //     console.log("Inside function")
  //     const response = await fetch(`${server}/api/time`);
  //     console.log(await fetch("http://192.168.49.2:31662/api/time"))
  //     console.log(await response.json())
  //     console.log(await response.text())
  //     const data = await response.json();
  //     setCurrentTime(data.time);
  //     setCallCount(data.callCount);
  //   };

  //   fetchData();
  // }, []);

  const updateTime = async () => {
    console.log("Inside function")
      const response = await fetch(`${server}/api/time`);
      // console.log(await response.json())
      // console.log(await response.text())
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
