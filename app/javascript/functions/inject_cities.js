import axios from 'axios';
import inject from './inject';

const injectCities = () => {
  const selectCountryElement = document.getElementById('country');

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
        default:
          break;
      }
    })
  }
}


export default injectCities;
