from tensorflow.keras.datasets import mnist
from tensorflow import keras
from tensorflow.keras import layers
import tensorflow as tf


from multiclass_model import fit_mnist_model, evaluate_mnist_model
from multiclass_model import get_mnist_data
from multiclass_model import define_dense_model_single_layer, define_dense_model_with_hidden_layer

def test_define_dense_model_single_layer():
    model = define_dense_model_single_layer(43, activation_f='sigmoid', output_length=1)
    assert len(model.layers) == 1, " model should have 1 layer"
    assert model.layers[0].input_shape == (None, 43), " input_shape is not correct"
    assert model.layers[0].output_shape == (None, 1), " output_shape is not correct"


def test_define_dense_model_with_hidden_layer():
    model = define_dense_model_with_hidden_layer(43, activation_func_array=['relu','sigmoid'], hidden_layer_size=11, output_length=1)
    assert len(model.layers) == 2, " model should have 2 layers"
    assert model.layers[0].input_shape == (None, 43), " input_shape is not correct"
    assert model.layers[0].output_shape == (None, 11), " output_shape is not correct"
    assert model.layers[1].output_shape == (None, 1), " output_shape is not correct"


def test_fit_and_predict_mnist_ten_neurons():
    model = define_dense_model_single_layer(28*28, activation_f='softmax', output_length=10)
    (x_train, y_train), (x_test, y_test) = get_mnist_data()
    model = fit_mnist_model(x_train, y_train, model)
    loss, accuracy = evaluate_mnist_model(x_train, y_train, model)
    print("train", loss, accuracy)
    assert accuracy > 0.9, " accuracy should be greater than 0.9"
    loss, accuracy = evaluate_mnist_model(x_test, y_test, model)
    print("test", loss, accuracy)
    assert accuracy > 0.9, " accuracy should be greater than 0.9"
   

def test_fit_and_predict_mnist_with_hidden_layers():
    model = define_dense_model_with_hidden_layer(28*28, activation_func_array=['sigmoid','softmax'], hidden_layer_size=50, output_length=10)
    (x_train, y_train), (x_test, y_test) = get_mnist_data()
    model = fit_mnist_model(x_train, y_train, model)
    loss, accuracy = evaluate_mnist_model(x_train, y_train, model)
    print("train", loss, accuracy)
    assert accuracy > 0.9, " accuracy should be greater than 0.9"
    loss, accuracy = evaluate_mnist_model(x_test, y_test, model)
    print("test", loss, accuracy)
    assert accuracy > 0.9, " accuracy should be greater than 0.9"
   
if __name__ == "__main__":
    test_fit_and_predict_mnist_ten_neurons()
    test_fit_and_predict_mnist_with_hidden_layers()