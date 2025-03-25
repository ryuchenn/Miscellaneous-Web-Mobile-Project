import React, { createContext, useState } from 'react';

export const RoomContext = createContext();

export const RoomProvider = ({ children }) => {
    const [roomData, setRoomData] = useState([
        { room: 'A101', cap: 5, avail: true },
        { room: 'A102', cap: 10, avail: false },
        { room: 'A103', cap: 8, avail: false },
        { room: 'A104', cap: 10, avail: true },
        { room: 'A105', cap: 7, avail: true }
    ]);

    return (
        <RoomContext.Provider value={{ roomData, setRoomData }}>
            {children}
        </RoomContext.Provider>
    );
};
