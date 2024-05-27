# ---------------------
# Base api utilization
# --------------------- 
 
_USER="${CONFLUENCE_USER}:${CONFLUENCE_PASSWORD}";
_BASE="https://YOUR-CONFLUENCE/confluence/rest/api/";
_PATH="${BASE}content/"
 
curl \
  --silent \
  --fail \
  --user "${_USER}" \
  --url "${_PATH}" \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json'
  
# ---------------------
# Searching using CQL
# --------------------- 
 
_USER="${CONFLUENCE_USER}:${CONFLUENCE_PASSWORD}";
_BASE="https://YOUR-CONFLUENCE/confluence/rest/api/";
_PATH="${BASE}/search?cql=(title~"TITLE*")&(spaceKey=SPACE)
 
curl \
  --silent \
  --fail \
  --user "${_USER}" \
  --url "${_PATH}" \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json'

# ---------------------
# Expanding content of particular page
# ---------------------

_USER="${CONFLUENCE_USER}:${CONFLUENCE_PASSWORD}";
_BASE="https://YOUR-CONFLUENCE/confluence/rest/api/";
_PATH="${BASE}/111222333/?expand=body.export_view
 
curl \
--silent \
--fail \
--user "${_USER}" \
 --url  "${_PATH}" \
--data 'expand=body.export_view' \
--header 'Content-Type: application/json'\
--header 'Accept: application/json'


# ---------------------
# Expanding content of particular page
# ---------------------
 
_USER="${CONFLUENCE_USER}:${CONFLUENCE_PASSWORD}";
_BASE="https://YOUR-CONFLUENCE/confluence/rest/api/";
_PATH="${BASE}/111222333/?expand=body.export_view
 
curl \
--silent \
--fail \
--user "${_USER}" \
 --url   "${_PATH}" \
--data 'expand=body.export_view' \
--header 'Content-Type: application/json'\
--header 'Accept: application/json'
