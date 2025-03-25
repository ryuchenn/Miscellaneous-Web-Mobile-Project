import React, { useState } from 'react';
import { View, Text, TouchableOpacity, Modal, StyleSheet } from 'react-native';
import LabelWithIcon from './LabelWithIcon';

const RoomDropdown = ({ title, selectedValue, onSelect, options }) => {
  const [visible, setVisible] = useState(false);
  const handleSelect = (item) => {
    onSelect(item);
    setVisible(false);
  };

  return (
    <View style={styles.container}>
      {title && <LabelWithIcon text={title} style={styles.title} />}
      <TouchableOpacity style={styles.btn} onPress={() => setVisible(true)}>
        <Text style={styles.btnText}>{selectedValue || "Select Room"}</Text>
      </TouchableOpacity>
      <Modal visible={visible} transparent animationType="fade">
        <TouchableOpacity style={styles.overlay} onPress={() => setVisible(false)}>
          <View style={styles.modal}>
            {options.map((option) => (
              <TouchableOpacity key={option} style={styles.item} onPress={() => handleSelect(option)}>
                <Text style={styles.itemText}>{option}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </TouchableOpacity>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
    alignItems: 'center',
  },
  title: {
    fontSize: 18,
    marginBottom: 5,
    fontWeight: 'bold',
  },
  btn: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 15,
    borderRadius: 5,
    width: 300,
    alignItems: 'center',
  },
  btnText: {
    fontSize: 18,
  },
  overlay: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  modal: {
    backgroundColor: 'white',
    borderRadius: 5,
    padding: 20,
    width: 300,
  },
  item: {
    paddingVertical: 15,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  itemText: {
    fontSize: 18,
  },
});

export default RoomDropdown;
