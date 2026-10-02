import {createContext,useContext,useState} from 'react';
const C=createContext();export const useAuth=()=>useContext(C);
export function AuthProvider({children}){const[user,setUser]=useState(()=>JSON.parse(localStorage.getItem('user')||'null'));const login=(u,t)=>{localStorage.setItem('user',JSON.stringify(u));localStorage.setItem('token',t);setUser(u)};const logout=()=>{localStorage.removeItem('user');localStorage.removeItem('token');setUser(null)};return <C.Provider value={{user,login,logout}}>{children}</C.Provider>}
