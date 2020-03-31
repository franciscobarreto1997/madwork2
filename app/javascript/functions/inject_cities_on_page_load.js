import inject from './inject';
import axios from 'axios';

const injectCitiesOnPageLoad = () => {
  axios.get('/fetch_portuguese_cities')
  .then(data => inject(data.data))
}

export default injectCitiesOnPageLoad;
