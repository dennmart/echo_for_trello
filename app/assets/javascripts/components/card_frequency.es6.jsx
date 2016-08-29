class CardFrequency extends React.Component {
  constructor(props) {
    super(props);
    this.updateFrequency = this.updateFrequency.bind(this);
    this.renderFrequencyOptions = this.renderFrequencyOptions.bind(this);
    this.updateFrequencyPeriod = this.updateFrequencyPeriod.bind(this);

    this.state = {
      frequency: this.props.frequency || "",
      frequencyPeriod: this.props.frequency_period || ""
    };
  }

  updateFrequency(event) {
    this.setState({ frequency: event.target.value });
  }

  updateFrequencyPeriod(event) {
    this.setState({ frequencyPeriod: event.target.value });
  }

  renderFrequencyOptions() {
    switch (parseInt(this.state.frequency)) {
      case 1: // Daily
        return this.renderDailyOptions();
        break;
      case 2: // Weekly
        return this.renderWeeklyOptions();
        break;
      case 3: // Monthly
        return this.renderMonthlyOptions();
        break;
      case 4: // Weekdays
        return this.renderWeekdayOptions();
        break;
      case 5: // Weekends
        return this.renderWeekendOptions();
        break;
    }
  }

  renderDailyOptions() {
    return (
      <div className="col-md-6 col-md-offset-4">
        <p>Your card will be created every day at midnight (Pacific Time).</p>
      </div>
    );
  }

  renderWeeklyOptions() {
    options = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].map((day, i) => {
      return <option value={i} key={day}>{day}</option>;
    });

    return (
      <div>
        <div className="col-md-2 col-md-offset-2 text-right">
          <label htmlFor="card_frequency_period" className="control-label">Day of the week:</label>
        </div>
        <div className="col-md-4">
          <select className="form-control" id="card_frequency_period" value={this.state.frequencyPeriod} name="card[frequency_period]" onChange={this.updateFrequencyPeriod}>
            {options}
          </select>
        </div>
      </div>
    );
  }

  renderMonthlyOptions() {
    options = Array(31).fill().map((_, i) => {
      return <option value={i + 1} key={i + 1}>{i + 1}</option>;
    });

    return (
      <div>
        <div className="col-md-2 col-md-offset-2 text-right">
          <label htmlFor="card_frequency_period" className="control-label">Day of the month:</label>
        </div>
        <div className="col-md-4">
          <select className="form-control" id="card_frequency_period" value={this.state.frequencyPeriod} name="card[frequency_period]" onChange={this.updateFrequencyPeriod}>
            {options}
          </select>
        </div>
      </div>
    );
  }

  renderWeekdayOptions() {
    return (
      <div className="col-md-6 col-md-offset-4">
        <p>Your card will be created every weekday (Monday through Friday) at midnight (Pacific Time).</p>
      </div>
    );
  }

  renderWeekendOptions() {
    return (
      <div className="col-md-6 col-md-offset-4">
        <p>Your card will be created every Saturday and Sunday at midnight (Pacific Time).</p>
      </div>
    );
  }

  renderFrequencyPeriodWarning() {
    if (this.state.frequency == 3 && this.state.frequencyPeriod > 28) {
      return (
        <div className="col-md-6 col-md-offset-3 text-center frequency-month-warning">
          <p className="bg-warning">
            Please note, on months with less than {this.state.frequencyPeriod} days, your card will be created in Trello on the last day of that month.
          </p>
        </div>
      );
    }
  }

  render() {
    return (
      <div>
        <div className="form-group">
          <div className="col-md-2 col-md-offset-2 text-right">
            <label htmlFor="card_frequency" className="control-label">Frequency:</label>
          </div>
          <div className="col-md-4">
            <select className="form-control" name="card[frequency]" id="card_frequency" value={this.state.frequency} onChange={this.updateFrequency}>
              <option value=""></option>
              <option value="1">Daily</option>
              <option value="2">Weekly</option>
              <option value="3">Monthly</option>
              <option value="4">Weekdays</option>
              <option value="5">Weekends</option>
            </select>
          </div>
        </div>
        <div className="form-group">
          {this.renderFrequencyOptions()}
        </div>
        <div className="frequency-period-warning">
          {this.renderFrequencyPeriodWarning()}
        </div>
      </div>
    );
  }
}

