import axios from 'axios';

const fetchJobs = (element, page) => {
  const div = document.getElementById(element);
  const results = document.querySelector('.results-container');

  if (div) {
    axios.get(`/${page}`)
      .then((data) => {
        console.log(data)
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
    // fetch('http://localhost:3000/fetch_home')
    //   .then(response => console.log(response.json()))
    //   .then((data) => {
    //     console.log(data)
    //   })
  }
}

export default fetchJobs;
