*** Settings ***
Documentation     Arquivo responsável por divponibilizar varíaveis

*** Variables ***
# URLS

${URL_FRONT}    http://localhost:3002
${URL_API}      http://localhost:3000/api/v1

${AUTH_BASE_URL}         ${URL_API}/auth
${REGISTER_ENDPOINT}     ${AUTH_BASE_URL}/register
${LOGIN_ENDPOINT}        ${AUTH_BASE_URL}/login
${ME_ENDPOINT}           ${AUTH_BASE_URL}/me
${PROFILE_ENDPOINT}      ${AUTH_BASE_URL}/profile

${ADMIN_EMAIL}          admin@example.com
${ADMIN_PASSWORD}       admin123      
${USER_EMAIL}           test@example.com    
${USER_PASSWORD}        password123     
${NEW_USER_NAME}        Novo Usuario Teste
${NEW_USER_PASSWORD}    senha456       

${ADMIN_TOKEN}          ${EMPTY}
${USER_TOKEN}           ${EMPTY}

#root=/register - section=Register Form

${REGISTER_FORM}                    css=.register-form
${REGISTER_HEADER}                  css=.register-container h1
${REGISTER_SUBHEADER}               css=#root > main > div > div > p
${NAME_INPUT}                       css=#name
${EMAIL_INPUT}                      css=#email
${PASSWORD_INPUT}                   css=#password
${CONFIRM_PASSWORD_INPUT}           css=#confirmPassword
${REGISTER_BUTTON}                  css=.btn-primary
${LOGIN_LINK}                       css=#root > main > div > div > div > p > a
${LOGOUT_BUTTON}                    css=#root > header > div > nav > ul > li:nth-child(5) > button


# HEADERS

&{DEFAULT_HEADERS}       Content-Type=application/json

# COMPONENTS
# header

${HEADER_CONTAINER}                    header > div.header-container
${HEADER_LOGO}                         ${HEADER_CONTAINER} > div.logo
${HEADER_NAV}                          ${HEADER_CONTAINER} > nav    
${NAV_MENU}                            ${HEADER_NAV}
${NAV_MENU_ITEMS}                      ${NAV_MENU} > ul > li
${NAV_MENU_LINKS}                      ${NAV_MENU_ITEMS} > a
${MENU_HOME}                           ${NAV_MENU_ITEMS}:nth-child(1) > a
${MENU_INICIO}                         ${NAV_MENU_ITEMS}:nth-child(2) > a
${MENU_LOGIN}                          ${NAV_MENU_ITEMS}:nth-child(3) > a
${MENU_REGISTER}                       ${NAV_MENU_ITEMS}:nth-child(4) > a
${MENU_MOVIES}                         ${NAV_MENU_ITEMS}:nth-child(5) > a


# root=/ - section=cards

${MOVIES_SECTION}             main > div > div.featured-movies
${MOVIES_GRID}                ${MOVIES_SECTION} > div
${MOVIE_CARD}                 main > div > div.featured-movies > div > div:nth-child(1)
${MOVIE_POSTER}               ${MOVIE_CARD} > div.movie-poster
${MOVIE_CLASSIFICATION}       ${MOVIE_POSTER} > div.movie-classification
${MOVIE_TITLE}                main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > h3
${MOVIE_DURATION}             main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-meta > span.movie-duration
${MOVIE_RELEASE}              main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-meta > span.movie-release
${MOVIE_GENRES}               main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-genres
${MOVIE_SYNOPSIS}             main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > p
${MOVIE_DETAILS_BUTTON}       main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > a
${MOVIES_TITLE}               ${MOVIES_SECTION} h2
  


# root=/ - section=features

${FEATURES_SECTION}                main > div > div.features-section
${FEATURES_TITLE}                  ${FEATURES_SECTION} h2
${FEATURES_LIST}                   ${FEATURES_SECTION} ul
${FEATURES_LIST_ITEMS}             ${FEATURES_LIST} li
${FEATURES_CTA_CONTAINER}          ${FEATURES_SECTION} .cta-buttons
${FEATURES_CTA_BUTTON}             main > div > div.features-section > div > a

${EXPECTED_FEATURES_TITLE}         Available Features
${EXPECTED_CTA_BUTTON_TEXT}        Ver todos os filmes em cartaz
${EXPECTED_CTA_BUTTON_HREF}        /movies

@{EXPECTED_FEATURES_LIST}          
...    Browse latest movie releases    
...    View movie details and trailers    
...    Select showtimes and seats    
...    Purchase tickets online    
...    Manage your reservations


#root=/ - section=footer

${FOOTER_CONTAINER}                .footer
${FOOTER_SECTIONS}                 .footer-section
${FOOTER_BOTTOM}                   .footer-bottom

${FOOTER_APP_SECTION}              .footer-section:nth-child(1)
${FOOTER_LINKS_SECTION}            .footer-section:nth-child(2)
${FOOTER_CONTACT_SECTION}          .footer-section:nth-child(3)
${FOOTER_SOCIAL_SECTION}           .footer-section:nth-child(4)

${FOOTER_APP_TITLE}                ${FOOTER_APP_SECTION} h3
${FOOTER_APP_DESCRIPTION}          ${FOOTER_APP_SECTION} p

${FOOTER_LINKS_TITLE}              ${FOOTER_LINKS_SECTION} h3
${FOOTER_LINKS_LIST}               ${FOOTER_LINKS_SECTION} ul
${FOOTER_LINKS_ITEMS}              ${FOOTER_LINKS_SECTION} ul li
${FOOTER_LINK_FILMES}              footer > div.container.footer-container > div:nth-child(2) > ul > li:nth-child(1) > a
${FOOTER_LINK_LOGIN}               footer > div.container.footer-container > div:nth-child(2) > ul > li:nth-child(2) > a
${FOOTER_LINK_REGISTER}            footer > div.container.footer-container > div:nth-child(2) > ul > li:nth-child(3) > a

${FOOTER_CONTACT_TITLE}            ${FOOTER_CONTACT_SECTION} h3
${FOOTER_CONTACT_EMAIL}            ${FOOTER_CONTACT_SECTION} p:nth-child(2)
${FOOTER_CONTACT_PHONE}            ${FOOTER_CONTACT_SECTION} p:nth-child(3)

${FOOTER_SOCIAL_TITLE}             ${FOOTER_SOCIAL_SECTION} h3
${FOOTER_SOCIAL_ICONS}             ${FOOTER_SOCIAL_SECTION} .social-icons
${FOOTER_SOCIAL_FACEBOOK}          ${FOOTER_SOCIAL_SECTION} a[href="https://facebook.com"]
${FOOTER_SOCIAL_TWITTER}           ${FOOTER_SOCIAL_SECTION} a[href="https://twitter.com"]
${FOOTER_SOCIAL_INSTAGRAM}         ${FOOTER_SOCIAL_SECTION} a[href="https://instagram.com"]

${FOOTER_COPYRIGHT}                .footer-bottom p

${EXPECTED_FOOTER_APP_TITLE}       Cinema App
${EXPECTED_FOOTER_APP_DESC}        Seu aplicativo completo para reserva de ingressos de cinema.
${EXPECTED_FOOTER_LINKS_TITLE}     Links Úteis
${EXPECTED_FOOTER_CONTACT_TITLE}   Contato
${EXPECTED_FOOTER_SOCIAL_TITLE}    Siga-nos
${EXPECTED_FOOTER_EMAIL}           contato@cinemaapp.com
${EXPECTED_FOOTER_PHONE}           Tel: (11) 5555-5555
${EXPECTED_FOOTER_COPYRIGHT}       © 2025 Cinema App. Todos os direitos reservados.


#root=/movies - section=Search Movies

${SEARCH_MOVIES_SECTION}            main > div.movies-container
${SEARCH_MOVIES_H1}                 ${SEARCH_MOVIES_SECTION} > h1
${SEARCH_MOVIES_INPUT}              ${SEARCH_MOVIES_SECTION} > div.filters-container > div.search-box > input[type=text]
${SEARCH_MOVIES_SELECT_FILTER}      ${SEARCH_MOVIES_SECTION} > div.filters-container > div.genre-filter > select
${SEARCH_MOVIES_OPTION_ALL}          ${SEARCH_MOVIES_SELECT_FILTER} > option[value=""]
${SEARCH_MOVIES_OPTION_ADVENTURE}    ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Adventure"]
${SEARCH_MOVIES_OPTION_DRAMA}        ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Drama"]
${SEARCH_MOVIES_OPTION_SCIFI}        ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Science Fiction"]
${SEARCH_MOVIES_OPTION_ACTION}       ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Action"]
${SEARCH_MOVIES_OPTION_FANTASY}      ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Fantasy"]
${SEARCH_MOVIES_OPTION_CRIME}        ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Crime"]
${SEARCH_MOVIES_OPTION_ROMANCE}      ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Romance"]
${SEARCH_MOVIES_OPTION_ANIMATION}    ${SEARCH_MOVIES_SELECT_FILTER} > option[value="Animation"]

${EXPECTED_SEARCH_MOVIES_H1}        Filmes em Cartaz
${EXPECTED_SEARCH_PLACEHOLDER}      Buscar filmes...
@{EXPECTED_GENRE_OPTIONS}           Todos os gêneros    Adventure    Drama    Science Fiction    Action    Fantasy    Crime    Romance    Animation

${SEARCH_MOVIES_GRID}               main > div > div.movies-grid 
${SEARCH_MOVIE_CARD}                       main > div > div.movies-grid > div.movie-card 
${SEARCH_MOVIE_POSTER}                      div.movie-poster
${SEARCH_MOVIE_CLASSIFICATION}              div.movie-classification
${SEARCH_MOVIE_TITLE}                       div.movie-info > h3
${SEARCH_MOVIE_DURATION}                    div.movie-info > div.movie-meta > span.movie-duration
${SEARCH_MOVIE_RELEASE}                     div.movie-info > div.movie-meta > span.movie-release
${SEARCH_MOVIE_GENRES}                      div.movie-info > div.movie-genres
${SEARCH_MOVIE_SYNOPSIS}                    div.movie-info > p.movie-synopsis
${SEARCH_MOVIE_DETAILS_BUTTON}             div.movie-info > .btn-primary
${SEARCH_MOVIES_TITLE}                     ${SEARCH_MOVIES_SECTION} h2


#root=/movies/The Avengers - section=Movie Details

${MOVIE_DETAILS_SECTION}              main > div.movie-detail-page
${MOVIE_DETAILS_TITLE}                ${MOVIE_DETAILS_SECTION} > h1
${MOVIE_DETAILS_CONTAINER}            ${MOVIE_DETAILS_SECTION} > .movie-detail-container
${MOVIE_DETAILS_HEADER}               ${MOVIE_DETAILS_CONTAINER} > .movie-detail-header
${MOVIE_DETAILS_POSTER}               ${MOVIE_DETAILS_HEADER} > div.movie-poster
${MOVIE_DETAILS_INFO}                 ${MOVIE_DETAILS_HEADER} > div.movie-info
${MOVIE_DETAILS_CLASSIFICATION}       ${MOVIE_DETAILS_INFO} > div.movie-meta > span.classification
${MOVIE_DETAILS_DURATION}             ${MOVIE_DETAILS_INFO} > div.movie-meta > span:nth-child(2)
${MOVIE_DETAILS_DIRECTOR}             ${MOVIE_DETAILS_INFO} > div.movie-meta > span.director
${MOVIE_DETAILS_GENRES_CONTAINER}     ${MOVIE_DETAILS_INFO} > div.movie-meta > div.genres
${MOVIE_DETAILS_GENRE_TAG}            ${MOVIE_DETAILS_GENRES_CONTAINER} > span.genre-tag
${MOVIE_DETAILS_SYNOPSIS}             ${MOVIE_DETAILS_CONTAINER} > div.movie-synopsis

${MOVIE_SESSIONS_SECTION}           main > div.movie-sessions
${MOVIE_SESSION_DATES_CONTAINER}    ${MOVIE_SESSIONS_SECTION} > div.session-date-group
${MOVIE_SESSION_DATE_TITLE}         ${MOVIE_SESSION_DATES_CONTAINER} > h3.session-date
${MOVIE_SESSION_TIMES_CONTAINER}    ${MOVIE_SESSION_DATES_CONTAINER} > div.session-times
${MOVIE_SESSION_CARD}               ${MOVIE_SESSION_TIMES_CONTAINER} > div.session-card
${MOVIE_SESSION_TIME}               ${MOVIE_SESSION_CARD} > div.session-time
${MOVIE_SESSION_THEATER}            ${MOVIE_SESSION_CARD} > div.session-theater
${MOVIE_SESSION_PRICE}              ${MOVIE_SESSION_CARD} > div.session-price
${MOVIE_SESSION_BUY_BUTTON}         ${MOVIE_SESSION_CARD} > a.session-button


${EXPECTED_GENERO_ONE_TEXT}       Adventure
${EXPECTED_GENERO_TWO_TEXT}       Action

