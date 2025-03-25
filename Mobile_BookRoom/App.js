import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import AppNavigator from './src/navigation/AppNavigator';
import { RoomProvider } from './src/context/RoomContext';

export default function App() {
  return (
    <RoomProvider>
      <NavigationContainer>
        <AppNavigator />
      </NavigationContainer>
    </RoomProvider>
  );
}
