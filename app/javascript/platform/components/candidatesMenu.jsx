import React from 'react'

const CandidatesMenu = props => (
  <div className='CandidatesMenu ch--main-menu'>
    <div className='ch--main-menu--left'>
      <h2 className='CandidatesCount'>{props.total_count} candidates</h2>
    </div>
    <div className='ch--main-menu--right'>
      <button onClick={props.exportCSV} className='btn btn-sm btn-primary export-caregivers' role="button">
        Export
        <i className='fa fa-cloud-download ml-2'></i>
      </button>
    </div>
  </div>
)

export default CandidatesMenu
