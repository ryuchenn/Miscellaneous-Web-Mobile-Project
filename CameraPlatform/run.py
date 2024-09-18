from app import app

if __name__ == "__main__":
    # app.run(debug=True)
    app.run(port=5000, host="0.0.0.0") # run on the docker website
    # app.run(port=5000)