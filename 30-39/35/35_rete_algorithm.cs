using System;

class Comparison {
    public static bool is_prop(string s) {
        return s[s.Length-1] == 'T' || s[s.Length-1] == 'F';
    }

    public static bool is_condition(string s) {
        // Console.WriteLine(s[s.Length-1]);
        return (s[s.Length-1] != 'T' && s[s.Length-1] != 'F') && s.Length != 0;
    }

    public static bool is_empty(string s) {
        return s.Length == 0;
    }
}

class ConditionCollector {

    private List<Condition> conditions = [];
    private List<Condition> alpha_memories = [];
    private List<Condition> beta_nodes = [];

    public Condition get_condition(string condition_name) {
        for(int i = 0; i < conditions.Count; i++) {
            if(conditions[i].name == condition_name) {
                return conditions[i];
            }
        }
        throw new Exception("condition does not exist");
    }

    public Condition? condition_exists(string condition_name) {
        for(int i = 0; i < conditions.Count; i++) {
            if(conditions[i].name == condition_name) {
                return conditions[i];
            }
        }
        return null;
    }

    public void add_Condition(Condition bn) {
        this.conditions.Add(bn);
    }

    public void add_beta_node(Condition bn) {
        this.beta_nodes.Add(bn);
    }

    public void collect_conditions(ConditionCollector cc, string[] lines) {
        int i = 0;

        while(i < lines.Length) {
            Console.WriteLine("'" + lines[i] + "'");
            
            if(Comparison.is_condition(lines[i])) {
                // it's a new condition
                Console.WriteLine("Creating new condition in collect conditions");
                Condition current_condition = new Condition(lines[i].Substring(0, lines[i].Length), cc);

                conditions.Add(current_condition);
                Console.WriteLine();
                i++;
                while(i < lines.Length) {
                    if(Comparison.is_prop(lines[i])){
                        Console.WriteLine("adding prop");
                        current_condition.add_prop(lines[i]);
                        i++;
                    } else {
                        if (Comparison.is_empty(lines[i])) {
                            i++;
                        }
                        break;
                    }
                }
                if(current_condition.is_alpha()) {
                    this.alpha_memories.Add(current_condition);
                }
            } 

            // Console.WriteLine("tralala");
            // Console.WriteLine()
            // Environment.Exit(1);
            // rogue line; report!
            // throw new Exception("rogue line detected");
        }
    }

    // private void add_condition()
    public List<Condition> apply_beta_nodes() {
        List<Condition> all_beta_nodes = [];

        for(int i=0; i < this.beta_nodes.Count; i++) {
            this.beta_nodes[i].set_state();
            if((bool) this.beta_nodes[i].state) {
                all_beta_nodes.Add(this.beta_nodes[i]);
            }
        }
        return all_beta_nodes;
    }

    public void create_beta_nodes(string[] lines) {
        int i = 0;

        while(i < lines.Length) {
            if(!Comparison.is_prop(lines[i])) {
                // it's a new Beta node
                Condition beta_node = new Condition(lines[i], this, true);
                beta_nodes.Append(beta_node);

                i++;
                while(true) {
                    if(Comparison.is_prop(lines[i])){
                        Condition condition = this.get_condition(lines[i]);
                        beta_node.add_condition(condition);
                        i++;
                    } else {
                        break;
                    }
                }
            }
            // rogue line; report!
            throw new Exception("rogue line detected in beta creation");
        }
    }

    public void print_conditions() {
        Console.WriteLine(this.conditions.Count);
        for(int i=0;i<this.conditions.Count;i++) {
            Console.WriteLine(this.conditions[i].name);
        }

        for(int i=0;i<this.alpha_memories.Count;i++) {
            Console.WriteLine(this.alpha_memories[i].name);
        }

    }
}

class Condition {

    private ConditionCollector cc;
    private List<Condition> list_of_prereqs = [];
    private bool is_beta_node = false;
    public bool state;
    public string name;

    public string get_name() {
        return this.name;
    }
    
    public void add_condition(Condition condition) {
        list_of_prereqs.Add(condition);
    }

    public Condition(string name, ConditionCollector cc, bool is_beta = false) {
        this.name = name;
        this.cc = cc;

        if(is_beta) {
            cc.add_beta_node(this);
        }      
    }

    public void add_prop(string new_cond) {
        Condition? new_condition = this.cc.condition_exists(new_cond);
        if(new_condition == null) {
            Console.WriteLine("creating new condition in add prop");
            new_condition = new Condition(new_cond, this.cc);
            this.cc.add_Condition(new_condition);
        }
        this.list_of_prereqs.Add(new_condition);
    }

    public bool is_alpha() {
        return this.list_of_prereqs.Count == 0;
    }

    public bool set_state() {
        if(this.state != null) {
            return (bool) this.state;
        }

        if(!is_beta_node) {
            throw new Exception("can't set state of a non-beta node");
        }


        for(int i=0;i<this.list_of_prereqs.Count;i++) {
            bool state = this.list_of_prereqs[i].set_state();
            if(!state) {
                this.state = false;
                return false;
            }
        }
        this.state = true;
        return true;
    }
}

class ReteAlgorithm {
    static void Main() {
        try {
            // See https://aka.ms/new-console-template for more information
            ConditionCollector cc = new ConditionCollector();

            string[] lines = File.ReadAllLines("select_nodes.txt");
            cc.collect_conditions(cc, lines);
            // cc.collect_conditions();

            Console.WriteLine("Here");
            cc.print_conditions();
            Environment.Exit(1);
            string[] lines_beta = File.ReadAllLines("beta_nodes.txt");
            cc.create_beta_nodes(lines_beta);

            List<Condition> betanodes = cc.apply_beta_nodes();

            for(int i=0; i < betanodes.Count; i++) {
                Console.WriteLine(betanodes[i].get_name());
            }
        } catch (Exception ex) {
            Console.WriteLine($"Error: {ex.Message}");
            Environment.Exit(1);
        }

    }
}
 