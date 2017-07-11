import React from 'react'

import CandidatesMenu from './candidatesMenu'
import CandidatesTable from './candidatesTable'
import Pagination from 'react-js-pagination'

const CandidatesListContainer = props => (
  <div className='CandidatesListContainer ch--sub-main'>
    <CandidatesMenu 
      {...props}
      total_count={props.total_count} 
      exportCSV={props.exportCSV}
    />
    <CandidatesTable {...props} />
    <nav className='CandidatesListPagination'>
    <Pagination
      itemsCountPerPage={25}
      totalItemsCount={props.total_count}
      pageRangeDisplayed={5}
      activePage={props.current_page} 
      pageCount={props.total_pages}
      itemClass={'page-item'}
      linkClass={'page-link'}
      nextPageText={'Next ›'}
      lastPageText={'Last »'}
      prevPageText={'‹ Prev'}
      firstPageText={'« First'}
      hideDisabled={true}
      onChange={props.handlePageChange}
      />
    </nav>
  </div>
)

export default CandidatesListContainer
