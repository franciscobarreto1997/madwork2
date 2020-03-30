import axios from 'axios';
import fetchJob from './fetch_job';

const fetchJobs = (element, page) => {
  const div = document.getElementById(element);
  const results = document.querySelector('.results-container');
  const resultsNavbarQuery = document.querySelector('.navbar.results #query');

  if (div) {
    axios.get(`/${page}`)
      .then((data) => {
        data.data.forEach((job) => {

          const card = `<div class="card" data-url=${job.url}>
                          <div class="card-info">
                            <p>${job.company}</p>
                            <p><strong>${job.title}</strong></p>
                            <p id="location">${job.location}</p>
                          </div>
                          <div class="description">
                          </div>
                        </div>`

          results.insertAdjacentHTML('afterbegin', card);
        })
        if (resultsNavbarQuery) {
          resultsNavbarQuery.insertAdjacentHTML('beforeend', `<h5>${data.data.length} Jobs found</h5>`)
        }
        fetchJob()
      })
  }
}

export default fetchJobs;