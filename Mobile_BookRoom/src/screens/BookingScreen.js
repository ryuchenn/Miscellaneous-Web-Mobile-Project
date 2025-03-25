import React, { useEffect, useContext } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { RoomContext } from '../context/RoomContext';
import LabelWithIcon from '../components/LabelWithIcon';

const BookingScreen = ({ route, navigation }) => {
    const { id, name, num, room } = route.params;
    const { roomData, setRoomData } = useContext(RoomContext);
    const bookedCount = parseInt(num);

    useEffect(() => {
        setRoomData(prevData =>
            prevData.map(item => {
                if (item.room === room) {
                    const newCap = item.cap - bookedCount;
                    return { ...item, cap: newCap, avail: newCap > 0 };
                }
                return item;
            })
        );
    }, []);

    return (
        <LinearGradient colors={['#f0f8ff', '#e6f7ff']} style={styles.container}>
            <View style={styles.content}>
                <Text style={styles.title}>Booking Confirmation</Text>
                <View style={styles.card}>
                    <Text style={styles.success}>Success</Text>
                    <View style={styles.detailRow}>
                        <LabelWithIcon icon="school-outline" text="Student ID:" style={styles.detailLabel} />
                        <Text style={styles.detailValue}>{id}</Text>
                    </View>
                    <View style={styles.detailRow}>
                        <LabelWithIcon icon="person-outline" text="Name:" style={styles.detailLabel} />
                        <Text style={styles.detailValue}>{name}</Text>
                    </View>
                    <View style={styles.detailRow}>
                        <LabelWithIcon icon="people-outline" text="Number of People:" style={styles.detailLabel} />
                        <Text style={styles.detailValue}>{num}</Text>
                    </View>
                    <View style={styles.detailRow}>
                        <LabelWithIcon icon="school-outline" text="Room:" style={styles.detailLabel} />
                        <Text style={styles.detailValue}>{room}</Text>
                    </View>
                </View>
                <TouchableOpacity
                    style={styles.button}
                    onPress={() =>
                        navigation.reset({
                            index: 0,
                            routes: [{ name: 'Dashboard' }],
                        })
                    }
                >
                    <Text style={styles.buttonText}>Back to Dashboard</Text>
                </TouchableOpacity>
            </View>
        </LinearGradient>
    );
};

const styles = StyleSheet.create({
    container: { flex: 1 },
    content: { flex: 1, padding: 20, justifyContent: 'center', alignItems: 'center' },
    title: { fontSize: 24, marginBottom: 20, textAlign: 'center', fontWeight: 'bold' },
    card: { backgroundColor: '#fff', padding: 20, borderRadius: 10, elevation: 3, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.2, shadowRadius: 2, marginVertical: 20, width: '90%', alignSelf: 'center' },
    success: { color: 'green', fontSize: 20, textAlign: 'center', marginBottom: 20, fontWeight: 'bold' },
    detailRow: { marginBottom: 10 },
    detailLabel: { fontWeight: 'bold', marginRight: 5, fontSize: 16 },
    detailValue: { fontSize: 16, marginLeft: 30 },
    button: { backgroundColor: '#007BFF', padding: 15, borderRadius: 10, alignItems: 'center', marginTop: 10, width: '90%', alignSelf: 'center' },
    buttonText: { color: '#fff', fontSize: 16 }
});

export default BookingScreen;
