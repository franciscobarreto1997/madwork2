import axios from 'axios';
import inject from './inject';

const injectCities = () => {
  const selectCountryElement = document.getElementById('country');
  const selectCityElement = document.getElementById('city');

  if (selectCountryElement) {
    selectCountryElement.addEventListener('change', (event) => {
      const selectedCountry = event.target.value;

      switch(selectedCountry) {
        case 'Portugal':
          axios.get('/fetch_portuguese_cities')
            .then(data => inject(data.data))
          break;
        case 'United States':
          axios.get('/fetch_american_states')
            .then(data => inject(data.data))
          break;
        case 'England':
          axios.get('/fetch_england_cities')
            .then(data => inject(data.data))
          break;
        case 'France':
          axios.get('/fetch_french_cities')
            .then(data => inject(data.data))
          break;
        case 'Germany':
          axios.get('/fetch_german_cities')
            .then(data => inject(data.data))
          break;
        case 'Spain':
          axios.get('/fetch_spanish_cities')
            .then(data => inject(data.data))
          break;
        case 'Netherlands':
          axios.get('/fetch_dutch_cities')
            .then(data => inject(data.data))
          break;
        case 'Italy':
          axios.get('/fetch_italian_cities')
            .then(data => inject(data.data))
          break;
        case 'Remote':
          if (selectCityElement) {
            selectCityElement.innerHTML = ""
            selectCityElement.insertAdjacentHTML('beforeend', `<option value="Remote">Remote</option>`)
          }
          break;
        default:
          break;
      }
    })
  }
}


export default injectCities;
