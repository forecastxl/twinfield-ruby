Op te lossen problemen tov vorige Twinfield lib:

* Vaak uitgelogd door user op andere pc/applicatie
* Mogelijkheid tot reconnect als dat gebeurt
* Session_id wordt niet gedeeld door de verschillende Twinfield services => invalid session_id
* Globale twinfield settings, niet handig voor multi user app
* Afsluiten van sessie met session.abandon <= werkt blijkbaar niet meer?

Maak configuration object met connectie settings:
  
  conf = Twinfield::Configuration.new(username, password, organisation, office?)

Doe Twinfield request
  
  request = Twinfield::Process.search(conf, params)

Of, maak session en voer dan request op sessie uit
  session = Twinfield::Session.new(conf)
  session.service(:process).action(:search, params)
of
  session = Twinfield::Session.new(conf)
  process = Twinfield::Process.new(session)
  process.search(params) / process.request(action, params)


  session = Session.new(conf)
  service = Process.new(session)
  service.request(action, parameters)
    session.get_token
    client = Savon.new(init)
    client.request(action, parameters)


  session = Session.new(username, password, organisation)
  Twinfield::Process.request(session, action, data)
    session gebruiken om nieuw savon object te maken en call te doen


  session = Session.new(username, password, organisation)
  session.service(:finder).request(action, data) of
  session.service(:finder).action(data)
      lookup finder object, create if missing
  