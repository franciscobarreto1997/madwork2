import axios from 'axios';
import fetchJob from './fetch_job';
import colorSourceButton from './color_source_button';
import introJs from 'intro.js';


const fetchJobs = (element, page) => {
  const div = document.getElementById(element);
  const results = document.querySelector('.results-container');
  const resultsNavbarQuery = document.querySelector('.navbar.results #query');
  const homePageContainer = document.querySelector('.home-page-container');

  if (div) {
    axios.get(`/${page}`)
      .then((data) => {
        data.data.forEach((job) => {
          const card = `<div class="card" data-url=${job.url}>
                          <div class="unopened-card">
                            <div class="card-info">
                              <p>${job.company}</p>
                              <p><strong>${job.title}</strong></p>
                              <p id="location">${job.location}</p>
                            </div>
                            <div class="source">
                              <a href=${job.url}>${job.source}</a>
                            </div>
                          </div>
                          <div class="description">
                          </div>
                        </div>`

          results.insertAdjacentHTML('afterbegin', card);
        })
        if (resultsNavbarQuery) {
          resultsNavbarQuery.insertAdjacentHTML('beforeend', `<h5>${data.data.length} Jobs found</h5>`);
        }
        colorSourceButton();
        fetchJob();
      }).then((data) => {
        if (homePageContainer) {
          document.querySelector('.card').setAttribute('data-intro', 'Click on the cards to see the job description');
          document.querySelector('.card .source a').setAttribute('data-intro', 'Click on the source button to see the job listing on the original page');
          introJs().start();
        }
      })
  }
}

export default fetchJobs;
