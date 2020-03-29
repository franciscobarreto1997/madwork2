import axios from 'axios';

const fetchJob = () => {
  const cards = document.querySelectorAll('.card');
  cards.forEach((card) => {
    card.addEventListener('click', (event) => {
      const url = card.dataset.url
      axios.post('/fetch_results', {
        url: url
      }).then((data) => {
        card.style.height = 'auto'
        card.insertAdjacentHTML('beforeend', data.data.description)
      })
    })
  })
}

export default fetchJob;
