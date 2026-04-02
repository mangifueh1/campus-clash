/// Takes in the team name and returns the first 3 letters as the short name.
String getTeamShortName(String teamName) {
  if (teamName.length <= 3) {
    return teamName.toUpperCase();
  }
  return teamName.substring(0, 3).toUpperCase();
}
