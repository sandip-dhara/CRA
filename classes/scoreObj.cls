public class scoreObj {
    User u;
	Group q;
	Boolean available;
    Integer score;
    String calc;
	private Boolean x = false;
		       
    public scoreObj() { score = 0; } 
    public scoreObj(User uP, Integer iP) 
      { u = uP; score = iP; }
    public scoreObj(User uP, Double dP, Boolean aP, String cP) 
      { u = uP; score = dP.intValue(); available = aP; calc = cP; }
    public scoreObj(Group gP) 
      { q = gP; }
        
    public User getUser() { return u; }
    public Group getQueue() { return q; }
    public Boolean getAvail() { return available; }
    public Integer getScore() { return score; }
    public String getCalc() { return calc; }

	public void setUser (User uP) { u = uP; }
	public void setQueue (Group gP) { q = gP; }
	public void setAvail (Boolean aP) { available = aP; }

	public void addVaporPts(String vap, Integer pts) {
		this.addVapor(vap, pts);
		this.score += pts;
	}

	private void addVapor(String s, Integer pts) {
		if (x) 
    		calc = calc + '::' + s + ':' + pts;
		else {  //first time through
    		calc = s + ':' + pts;
    		x = true;
		}
	}
}

/*
old class definition here
public class scoreObj {
    User u;
	Group q;
	Boolean available;
    Integer score;
    String calc;
	       
    public scoreObj(User uP, Integer iP) 
      { u = uP; score = iP; }
    public scoreObj(User uP, Double dP, Boolean aP, String cP) 
      { u = uP; score = dP.intValue(); available = aP; calc = cP; }
    public scoreObj(Group gP) 
      { q = gP; }
        
    public User getUser() { return u; }
    public Group getQueue() { return q; }
    public Boolean getAvail() { return available; }
    public Integer getScore() { return score; }
    public String getCalc() { return calc; }
}
*/