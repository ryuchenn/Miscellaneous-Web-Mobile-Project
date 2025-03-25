import React, { useState, useContext } from 'react';
import { Alert, TextInput, View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import LabelWithIcon from '../components/LabelWithIcon';
import RoomDropdown from '../components/RoomDropdown';
import { RoomContext } from '../context/RoomContext';

const DashboardScreen = ({ navigation }) => {
    const { roomData } = useContext(RoomContext);
    const [id, setId] = useState('');
    const [name, setName] = useState('');
    const [num, setNum] = useState('');
    const [room, setRoom] = useState('A101');
    const [errorMsg, setErrorMsg] = useState('');

    const currentRoom = roomData.find(r => r.room === room);

    const check = () => {
        if (!id.trim() || !name.trim() || !num.trim()) {
            Alert.alert('Error', 'Please fill all fields');
            return;
        }
        const count = parseInt(num);
        if (isNaN(count)) {
            Alert.alert('Error', 'Number of People must be a number');
            return;
        }
        if (!currentRoom) {
            setErrorMsg('Invalid room selection');
            return;
        }
        if (!currentRoom.avail) {
            setErrorMsg('Room is not available');
            return;
        }
        if (count > currentRoom.cap) {
            setErrorMsg('Not enough capacity');
            return;
        }
        setErrorMsg('');
        navigation.navigate('Booking', { id, name, num, room });
    };

    return (
        <LinearGradient colors={['#f0f8ff', '#e6f7ff']} style={styles.container}>
            <View style={styles.content}>
                <TouchableOpacity style={styles.logoutButton} onPress={() => navigation.replace('SignIn')}>
                    <Ionicons name="log-out-outline" size={24} color="black" />
                </TouchableOpacity>
                <Text style={styles.title}>Dashboard</Text>
                <LabelWithIcon icon="school-outline" text="Student ID" style={styles.label} />
                <TextInput style={styles.input} placeholder="Student ID" value={id} onChangeText={setId} />
                <LabelWithIcon icon="person-outline" text="Name" style={styles.label} />
                <TextInput style={styles.input} placeholder="Name" value={name} onChangeText={setName} />
                <LabelWithIcon icon="people-outline" text="Number of People" style={styles.label} />
                <TextInput style={styles.input} placeholder="Number of People" keyboardType="numeric" value={num} onChangeText={setNum} />
                <RoomDropdown title="Room" selectedValue={room} onSelect={setRoom} options={['A101', 'A102', 'A103', 'A104', 'A105']} />
                <View style={styles.panel}>
                    <Text style={[styles.panelText, { color: currentRoom ? (currentRoom.avail ? 'green' : 'red') : '#000' }]}>
                        Available: {currentRoom ? (currentRoom.avail ? 'Yes' : 'No') : '-'}
                    </Text>
                    <Text style={styles.panelText}>Capacity: {currentRoom ? currentRoom.cap : '-'}</Text>
                </View>
                {errorMsg ? <Text style={styles.error}>{errorMsg}</Text> : null}
                <TouchableOpacity style={styles.button} onPress={check}>
                    <Text style={styles.buttonText}>Book</Text>
                </TouchableOpacity>
            </View>
        </LinearGradient>
    );
};

const styles = StyleSheet.create({
    container: { flex: 1 },
    content: { flex: 1, padding: 20, justifyContent: 'center', alignItems: 'center' },
    logoutButton: { position: 'absolute', top: 40, right: 20, zIndex: 10 },
    title: { fontSize: 24, marginBottom: 20, textAlign: 'center', fontWeight: 'bold' },
    label: { fontSize: 16, marginBottom: 5, marginLeft: 10 },
    input: { height: 40, borderWidth: 1, borderRadius: 10, marginBottom: 10, paddingHorizontal: 10, width: 300, backgroundColor: '#fff' },
    panel: { marginVertical: 10, alignItems: 'flex-start', width: 300 },
    panelText: { fontSize: 16, textAlign: 'left' },
    error: { color: 'red', textAlign: 'center', marginBottom: 10 },
    button: { backgroundColor: '#007BFF', padding: 15, borderRadius: 10, alignItems: 'center', width: '90%', alignSelf: 'center', marginTop: 10 },
    buttonText: { color: '#fff', fontSize: 16 }
});

export default DashboardScreen;
