const injectCities = () => {
  const selectCountryElement = document.getElementById('country');
  const selectCityElement = document.getElementById('city');

  if (selectCountryElement) {
    selectCountryElement.addEventListener('change', (event) => {
      const selectedCountry = event.target.value;

      switch(selectedCountry) {
        case 'Portugal':
          console.log('Portugal');
          break;
        case 'United States':
          console.log('United States');
          break;
        case 'England':
          console.log('England');
          break;
        default:
          break;
      }
    })
  }

}

export default injectCities;
