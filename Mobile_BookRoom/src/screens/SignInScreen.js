import React, { useState } from 'react';
import { Alert, TextInput, View, Text, TouchableOpacity, StyleSheet, Image } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import LabelWithIcon from '../components/LabelWithIcon';

const SignInScreen = ({ navigation }) => {
  const [user, setUser] = useState('');
  const [pwd, setPwd] = useState('');

  const login = () => {
    if (user.toLowerCase() === 'admin' && pwd.toLowerCase() === 'admin') {
      navigation.replace('Dashboard');
    } else {
      Alert.alert('Error', 'Invalid credentials');
    }
  };

  return (
    <LinearGradient colors={['#f0f8ff', '#e6f7ff']} style={styles.container}>
      <View style={styles.content}>
        <Image
          source={require('../../assets/logo.png')} 
          style={styles.logo}
          resizeMode="contain"
        />

        <Text style={styles.title}>Sign In</Text>

        <LabelWithIcon icon="person-outline" text="Username" style={styles.label} />
        <TextInput
          style={styles.input}
          placeholder="Username"
          value={user}
          onChangeText={setUser}
        />

        <LabelWithIcon icon="lock-closed-outline" text="Password" style={styles.label} />
        <TextInput
          style={styles.input}
          placeholder="Password"
          secureTextEntry
          value={pwd}
          onChangeText={setPwd}
        />

        <TouchableOpacity style={styles.button} onPress={login}>
          <Text style={styles.buttonText}>Login</Text>
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    padding: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  logo: {
    width: 400,
    height: 400,
    marginBottom: 20,
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
    textAlign: 'center',
    fontWeight: 'bold',
  },
  label: {
    fontSize: 16,
    marginBottom: 5,
    marginLeft: 10,
  },
  input: {
    height: 40,
    borderWidth: 1,
    borderRadius: 10,
    marginBottom: 10,
    paddingHorizontal: 10,
    width: 300,
    backgroundColor: '#fff',
  },
  button: {
    backgroundColor: '#007BFF',
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    width: 300,
    marginTop: 10,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
  },
});

export default SignInScreen;
