// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js

window.onload = function() {
  Particles.init({
    selector: '.background',
    color: '#75A5B7',
    maxParticles: 130,
    connectParticles: true,
    responsive: [
      {
        breakpoint: 768,
        options: {
          maxParticles: 80
        }
      }, {
        breakpoint: 375,
        options: {
          maxParticles: 50
        }
      }
    ]
  });
};
