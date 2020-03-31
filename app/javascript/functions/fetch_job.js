import axios from 'axios';

const fetchJob = () => {
  const cards = document.querySelectorAll('.card');
  const descriptionParagraph = document.getElementById('description');

  cards.forEach((card) => {
    card.addEventListener('click', (event) => {
      const url = card.dataset.url

      if (card.querySelector('#description')) {
        card.style.height = '100px'
        card.style.lineHeight = '0.6'
        card.querySelector('.description').innerHTML = ''
      } else {
        axios.post('/fetch_results', {
          url: url
        }).then((data) => {
          console.log(data.data)
          card.style.height = 'auto'
          card.style.lineHeight = '1.8'
          card.querySelector('.description').insertAdjacentHTML('afterbegin', `<p>${data.data.posted_date}</p>`)
          card.querySelector('.description').insertAdjacentHTML('beforeend', `<p id="description">${data.data.description}</p>`)
        })
      }
    })
  })
}

export default fetchJob;
