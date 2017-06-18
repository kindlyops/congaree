import React from 'react'
import ProfileDetails from './profileDetails'
import ProfileHeader from './profileHeader'
import ProfileNotes from './profileNotes'

class ConversationProfile extends React.Component {
  render() {
    return ( 
      <div className="profile">
        <ProfileHeader contact={this.props.contact} />
        <ProfileDetails contact={this.props.contact} />
        <ProfileNotes
          current_account={this.props.current_account}
          inbox={this.props.inbox}
          contact={this.props.contact} />
    </div>
    )
  }

  componentDidUpdate() {
    let toolTips = $('.Inbox [data-toggle="tooltip"]');
    toolTips.attr('data-animation', false);
    toolTips.tooltip();
  }
}

export default ConversationProfile
