import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';

const LabelWithIcon = ({ icon, text, style }) => (
    <View style={styles.labelContainer}>
        {icon ? <Ionicons name={icon} size={20} style={styles.labelIcon} /> : null}
        <Text style={[styles.labelText, style]}>{text}</Text>
    </View>
);

const styles = StyleSheet.create({
    labelContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 10,
        width: '100%',
    },
    labelIcon: {
        marginRight: 5,
    },
    labelText: {
        textAlign: 'left',
        fontWeight: 'bold',
    },
});

export default LabelWithIcon;
