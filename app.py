from flask import Flask

# Create a Flask app object
app = Flask(__name__)

# Define a route and a function to handle requests to that route
@app.route('/')
def hello_world():
    return 'Hello, World!'

# Define another route function for an about page
@app.route('/about')
def about():
    return 'This is the about page.'

# Run the app
if __name__ == '__main__':
    app.run()
