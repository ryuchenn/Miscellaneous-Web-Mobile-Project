import os

file_path = 'app/public/data/priceTest.csv'

if os.path.exists(file_path):
    print("檔案路徑存在。")
else:
    print("檔案路徑不存在。")