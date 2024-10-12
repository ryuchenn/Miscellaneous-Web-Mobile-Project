import numpy as np

def rmse(predictions, targets):
    pred = np.array(predictions)
    tar = np.array(targets)
    rmse = np.sqrt(np.mean((pred - tar) ** 2)) # TODO: Implement RMSE Calculation here...
    return rmse