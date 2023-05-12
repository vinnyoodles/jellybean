import React from "react";

export default class Home extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            question: ""
        };
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(event) {
        this.setState({question: event.target.value});
    }

    handleSubmit(event) {
        event.preventDefault();
        alert('Submitted question: ' + this.state.question);
      }

    render() {
        return (
            <div className="pt-5 w-50 mx-auto">
                <form className="d-flex flex-column" onSubmit={this.handleSubmit}>
                    <label>Ask a question:</label>
                    <textarea type="text" id="question" value={this.state.question} onChange={this.handleChange}>
                    </textarea>
                    <input type="submit" value="Submit"/>
                </form>
            </div>
        );
    }
};