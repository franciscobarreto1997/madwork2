import axios from 'axios';

const fetchJob = () => {
  const cards = document.querySelectorAll('.card');
  const descriptionParagraph = document.getElementById('description');
  const mediaQuery = window.matchMedia( "(max-width: 812px)");

  cards.forEach((card) => {
    card.addEventListener('click', (event) => {
      const url = card.dataset.url

      if (card.querySelector('#description')) {
        if (mediaQuery.matches) {
          card.style.height = '175px'
          card.style.lineHeight = '1.0'
        } else {
          card.style.height = '100px'
          card.style.lineHeight = '0.6'
        }
        card.querySelector('.description').innerHTML = ''
      } else {
        axios.post('/fetch_results', {
          url: url
        }).then((data) => {
          console.log(data.data)
          card.style.height = 'auto'
          card.style.lineHeight = '1.8'
          card.querySelector('.description').insertAdjacentHTML('beforeend', `<p id="description">${data.data.description}</p>`)
        })
      }
    })
  })
}

export default fetchJob;
