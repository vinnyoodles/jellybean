import React from "react";

export default class Home extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            question: "",
            answer: null,
        };
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);

        this.showAnswer = this.showAnswer.bind(this);
    }

    showAnswer(response) {
        this.setState({answer: response.answer})
    }

    handleChange(event) {
        this.setState({question: event.target.value});
    }

    handleSubmit(event) {
        event.preventDefault();

        if (this.state.question.length == 0) {
           return;
        }

        const url = "/api/v1/question/create";
        const body = {question: this.state.question}
        const token = document.querySelector('meta[name="csrf-token"]').content;
        fetch(url, {
          method: "POST",
          headers: {
            "X-CSRF-Token": token,
            "Content-Type": "application/json",
          },
          body: JSON.stringify(body),
        })
          .then((response) => {
            if (response.ok) {
              return response.json();
            }
            throw new Error("Failed to ask question");
          })
          .then(this.showAnswer)
          .catch((error) => console.log(error.message));
    };

    render() {
        let answer;
        if (this.state.answer) {
            answer = <p>{this.state.answer}</p>
        }
        return (
            <div className="pt-5 w-50 mx-auto">
                <form className="d-flex flex-column" onSubmit={this.handleSubmit}>
                    <label>Ask a question:</label>
                    <textarea type="text" id="question" value={this.state.question} onChange={this.handleChange}>
                    </textarea>
                    <input type="submit" value="Submit"/>
                </form>
                {answer}
            </div>
        );
    }
};