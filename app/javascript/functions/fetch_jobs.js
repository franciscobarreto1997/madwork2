import axios from 'axios';

const fetchJobs = () => {
  const search = document.getElementById('search');
  const results = document.querySelector('.results-container');

  if (search) {
    axios.get('/fetch')
      .then((data) => {
        console.log(data.data)
        data.data.forEach((job) => {

          const card = `<div class="card">
                          <div class="card-info">
                            <p>${job.company}</p>
                            <p><strong>${job.title}</strong></p>
                            <p>${job.location}</p>
                          </div>
                        </div>`

          results.insertAdjacentHTML('afterbegin', card)
        })
      })
  }
}

export default fetchJobs;
